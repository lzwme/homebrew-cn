class Flowrs < Formula
  desc "TUI application for Apache Airflow"
  homepage "https://github.com/jvanbuel/flowrs"
  url "https://ghfast.top/https://github.com/jvanbuel/flowrs/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "48c4e87132ce8c9469cd471eb1e21c18ac0d60ea889188197f11504300a022d7"
  license "MIT"
  head "https://github.com/jvanbuel/flowrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97f8bd1c949a62f80d17eb494c9d709c8050011f062252274f52d6400b14325d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cb9fe8ae6f8d3041438cfd9ac8af3046af7a63f56c92676a6b3533748ab683f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e7d0b4a2c6ca264abb6fb59f832007056cbf2f9a2589ea7d1de29c6f0ad991f"
    sha256 cellar: :any_skip_relocation, sonoma:        "663de9ed0eb1b538b1f9629ff53981e1cb9bd53f7686c4237c63017d1777c68b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ee65585113ad8e785d61d30420b9c45ab26529475b9d713e6d829f5f17bfad0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2bff0b4bd82866c7f7df2446b8d1305c877017639769d45d107b76647a887c0"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/flowrs --version")
    assert_match "No servers found in the config file", shell_output("#{bin}/flowrs config list")
  end
end