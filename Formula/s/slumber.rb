class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://ghfast.top/https://github.com/LucasPickering/slumber/archive/refs/tags/v5.4.3.tar.gz"
  sha256 "9876d10714cd4b9f93f42916ea7b60821788e40ee503618524751ac74c0a52a4"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2298cf354892a2e5f19b633d78410fc4cd8b457da33b4dd676889de0ec39259b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b4500a6e1171d9193c8bd4beb864e02411f45cb8b4e34505acf4b17aff3d941d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "fdffcc1593ba1779ebec621f088b8aeb7d73e5f22adcf9fdd5d70ee504aa66c6"
    sha256 cellar: :any,                 arm64_linux:       "f39b2710a9ef145a7b74737e2776c5045fc60ced28a8534e33386f4d339f36d1"
    sha256 cellar: :any,                 x86_64_linux:      "fbd63046ac64135c9cf9ed0febd2ca510085367f7c914d562508567a4a9469ae"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"slumber", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end