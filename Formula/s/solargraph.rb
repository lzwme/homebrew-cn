class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.55.1",
      revision: "aadbce6145c919bb76362ace00353dac2ab02363"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3739e1692c2d06eb51e10de850f7c0806956fe51926ff526bb3e4e192601d037"
    sha256 cellar: :any,                 arm64_sonoma:  "7fef1c9d0edb46a7663bbb8d847389e4b599c67f85978b307870ddbdb753307d"
    sha256 cellar: :any,                 arm64_ventura: "a862ee05cf3091df9c653ed23c47f5151d83eb833805a1611f9d28df305ecce4"
    sha256 cellar: :any,                 sonoma:        "dda43057cba7871cb050e08dcb9b06e48bd349e0a4f59560c2188bc50d325205"
    sha256 cellar: :any,                 ventura:       "3eb8435314aca803758e53b8a9c1ff775a4f71459262d25077ddf245eb365df9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d32d70eec713ea4d5a3de6aec78e909edd2790cd39c17d11fe763a5585197bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd3be549c806c69ecdd49727c4685e6c10403d3beb7419c98f5e0fbdcd4e2fe5"
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