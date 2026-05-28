class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https://ryelang.org/"
  url "https://ghfast.top/https://github.com/refaktor/rye/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "2b6962dd01deff4e659bb62465cfecc35f160f94fcca63bca061a3147a877276"
  license "BSD-3-Clause"
  head "https://github.com/refaktor/rye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3d1fb1e6a6eddd20856d0f7f71cfdf153af72b3e4ee1d11d11545bf92440e465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e58a499322bf420fc2f4369a3fef74b47b83fd9572c59856d5b5e776e03d2ce2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9536833020d25e9db43d88035226dcfcb3c39c861aa32fe4dca0e44c32f8f841"
    sha256 cellar: :any_skip_relocation, sonoma:        "65586e12c99dca07b8036d5470197722034ba0c71899b3e483283f398a2fd39d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4ec8d2303c7790dd451d0ce65c11486743fc640aa3b98010b25df803bf9605a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68398f7ec2a3f6bdaffae3cda1288389fde574c7157b82b2620a60167987a426"
  end

  depends_on "go" => :build

  conflicts_with "rye", because: "both install `rye` binaries"

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    ldflags = %W[
      -s -w
      -X github.com/refaktor/rye/runner.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin/"rye")
    bin.install_symlink "rye" => "ryelang" # for backward compatibility
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rye --version")

    (testpath/"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_path_exists testpath/"hello.rye"
    output = shell_output("#{bin}/rye hello.rye 2>&1")
    assert_match "Hello Mars\n42", output.strip
  end
end