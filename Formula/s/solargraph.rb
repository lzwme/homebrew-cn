class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.55.2",
      revision: "08f2af7e95c6a15501f37461f12816426acab1dc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4229d61f66f488e12f2d47661be19604012112d818c25c30c53500175f240559"
    sha256 cellar: :any,                 arm64_sonoma:  "ab4556bd1fcaf83cb4337653474405a365f13379ddf4286e0ad5c89baf7e9dab"
    sha256 cellar: :any,                 arm64_ventura: "510cdb05290ed777cf9e5d5ba31df41ae4c5f14daed9a1615135436ec5722b70"
    sha256 cellar: :any,                 sonoma:        "1e84c85944b83e28b1404bb4b4f902381f05b2bf61fc0d3021b66991a6100acf"
    sha256 cellar: :any,                 ventura:       "df59d4b36192c768d52c6cc87781335c1f9e5292fa204e36fa4bef658809d43d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6bb694c23229f485ce2d8e3466540e5aae32b7c77b908b3c9ba5d512ca062758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce38b203f32e13120d032e2ebb02927e1f79aa342d644f710a6026802a28d673"
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