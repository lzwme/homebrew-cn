class Diskwatch < Formula
  desc "Cross-platform disk diagnostics TUI"
  homepage "https://www.netwatchlabs.com/labs/diskwatch"
  url "https://ghfast.top/https://github.com/matthart1983/diskwatch/archive/refs/tags/v0.5.0.tar.gz"
  sha256 "ce698b40ef33660ab19fe4f77eecc80b0fe88ef95a79c9db2a9bf80a8d3324f3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "450f2a65442ba22313909ec5676f21c07cf9250a123ebe0e946ece266b99bd58"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b19a36912719f78af84405de0e51246fc1795339fd4616d536e8cfe15d829ca6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "926495b6de80f3c04bb8d719370ef060b896e00acc352fcd484f5ffdc7dd8694"
    sha256 cellar: :any,                 arm64_linux:   "8c7b5e6cb9b335ca7c87f14445d5d1477276f0c3b18b145a00fb6dc1a9e99709"
    sha256 cellar: :any,                 x86_64_linux:  "7d01cb8640d45aa25a5b148e76fb273c67f27d58a43d64fcca78e2526651067a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Devices", shell_output("#{bin}/diskwatch --diag")
  end
end