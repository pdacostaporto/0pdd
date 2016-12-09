# encoding: utf-8
#
# Copyright (c) 2016 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require_relative 'exec'

#
# Repository in Git
#
class GitRepo
  def initialize(name:, dir: '/tmp/0pdd')
    @name = name
    @path = "#{dir}/#{@name}"
  end

  def push
    if File.exist?(@path)
      pull
    else
      clone
    end
  end

  def clone
    Exec.new(
      preamble,
      'git clone',
      '--depth=1',
      "git@github.com:#{@name}",
      @path
    ).run
  end

  def pull
    Exec.new(
      preamble,
      'git',
      "--git-dir=#{@path}/.git",
      'pull'
    ).run
  end

  def preamble
    [
      'set -x',
      'set -e',
      'mkdir -p ~/.ssh',
      'echo "Host *" > ~/.ssh/config',
      'echo "  StrictHostKeyChecking no" >> ~/.ssh/config',
      'echo "  UserKnownHostsFile=/dev/null" >> ~/.ssh/config',
      'chmod -R 600 ~/.ssh/*'
    ].join('; ') + ';'
  end
end