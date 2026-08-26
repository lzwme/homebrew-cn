class NetworkDoctor < Formula
  desc "Network troubleshooting TUI"
  homepage "https://github.com/heymaikol/network-doctor/"
  url "https://ghfast.top/https://github.com/heymaikol/network-doctor/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "d204353d7380da47cee4a0959a1222c96b960bfa045f13c48204d873ccd23347"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "649b0c3b60465ea8a73f6786e5c3c54667fa7cf1d26b79a511d2fee9cdb1bec3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "649b0c3b60465ea8a73f6786e5c3c54667fa7cf1d26b79a511d2fee9cdb1bec3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "649b0c3b60465ea8a73f6786e5c3c54667fa7cf1d26b79a511d2fee9cdb1bec3"
    sha256 cellar: :any_skip_relocation, sonoma:        "db5c9e1120df70e6eb6098e2f2dd3f35eec436dcb64312a36049385d71fc757b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afeefeb2d95b705499d4ae49fdb30b07054a07b34404caadc62870e5ebb94ec0"
    sha256 cellar: :any,                 x86_64_linux:  "3868a28ed74b9ce4cf67f5c07ea772e43eb754ad605fa3768b69afb32f164901"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}", output: bin/"netdoc")
  end

  test do
    output = JSON.parse shell_output("#{bin}/netdoc -json")
    assert_equal version.to_s, output["version"]
    assert_equal true, output["checks"].any? { |hash| hash["id"] == "iface" && hash["status"] == "PASS" }
  end
end