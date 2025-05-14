class Solargraph < Formula
  desc "Ruby language server"
  homepage "https:solargraph.org"
  # Must be git, because solargraph.gemspec uses git ls-files
  url "https:github.comcastwidesolargraph.git",
      tag:      "v0.54.3",
      revision: "414d40afd1015ce7ad682412ac4669c548a89bce"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "47a3383918cf7d2023ad3e58b01aacaf78cec3c8fd4cfe329787959538765d2c"
    sha256 cellar: :any,                 arm64_sonoma:  "b70208727a32a9e3b00d3845d548228aed4f1e70f79b897d8536deae6c45705d"
    sha256 cellar: :any,                 arm64_ventura: "30972ac826baa6466bb4c256ad2a83bd6ff7877ca5b9eef5ba729d10a51068e2"
    sha256 cellar: :any,                 sonoma:        "baade9b24a8e946348edca4822a4013fec6257ec239837fb31108faf87c5f983"
    sha256 cellar: :any,                 ventura:       "65bc79773ceabc3f6d4ca2960bcbf20838e022709cd63484b8ef8ae4edf2efac"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e77e7754b28f39670ee539ef4e557bc3a38ac6eb74786479ea22be522c4c8688"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "883605d2776919f0eaf263b7cb22e2597a7194c40be56249b6ce136995ed9aea"
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