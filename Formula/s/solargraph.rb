class Solargraph < Formula
  desc "Ruby language server"
  homepage "https://solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https://github.com/castwide/solargraph.git",
      tag:      "v0.56.2",
      revision: "6d140fa9bb1c915879215220ecf2a3bcbb27a97d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2e779827d049ccd0077554f43eb9ff678b616320f7cbfd3557ad792f1d4c4306"
    sha256 cellar: :any,                 arm64_sonoma:  "bfdc58ba6d89628279886bc20d392fc546cf8481caf0686ee5365b957c8d8ff2"
    sha256 cellar: :any,                 arm64_ventura: "2a62c282b79cbbb41f30c0044f642f23ac11741eadeb2f1ac0e48bc49598b65a"
    sha256 cellar: :any,                 sonoma:        "c698d4a7633a419d9416da5ded35bc81cb87a9ceefad3981babad359a0f93309"
    sha256 cellar: :any,                 ventura:       "43a0b780c816ec3daa74a6547893215d63fb664b2feae64b6422c0799d26a09f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "223f8527407b67d6f2279c5780f6148a2ef195aef478bcdf7a7d67da9424afa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b84213882cbb7330da497878d64527bcd2e51e26b37a8b87ccf08801154f931"
  end

  depends_on "ruby" # Requires >= Ruby 2.7

  depends_on "xz"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec/"bin/#{name}"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
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

    Open3.popen3(bin/"solargraph", "stdio") do |stdin, stdout, _, _|
      stdin.write "Content-Length: #{json.size}\r\n\r\n#{json}"
      sleep 3
      assert_match(/^Content-Length: \d+/i, stdout.readline)
    end
  end
end