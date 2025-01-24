class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.51.1",
      revision: "e3356c5cac97a336d0337fd9e187a0ddfeac45ce"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2d654d2dd071a8971b6875eeae818eda8241aa53ffe189c06c3c9f954243e075"
    sha256 cellar: :any,                 arm64_sonoma:  "3fbc5893d4f2909ccc6ff7248715875963bc61bec07cd7a1856aec8a3617da24"
    sha256 cellar: :any,                 arm64_ventura: "81cc116cc5f8617ccc50d0f9d6976431f69e31810ea9e4ecec52177b267eddaf"
    sha256 cellar: :any,                 sonoma:        "167f20fc9c963d4d6b1c984a399b7669c4dbe9a5d943466d567eb85ddfc3ab84"
    sha256 cellar: :any,                 ventura:       "0457b897d1fed5ed5ea2b85e371ee877427d0a2ea91cb1caef095fc0c8ed20d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "18466867ad72cd31b07c3a7a07e2a4cf2739afe7da4b52d0f50361de0aebf1a7"
  end

  depends_on "ruby" # Requires >= Ruby 2.7

  depends_on "xz"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec"bin#{name}"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    require "open3"

    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON

    Open3.popen3(bin"solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(^Content-Length: \d+i, stdout.readline)
    end
  end
end