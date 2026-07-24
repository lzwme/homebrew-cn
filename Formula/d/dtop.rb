class Dtop < Formula
  desc "Terminal dashboard for Docker monitoring across multiple hosts"
  homepage "https://dtop.dev/"
  url "https://ghfast.top/https://github.com/amir20/dtop/archive/refs/tags/v0.7.10.tar.gz"
  sha256 "2365d73f398142b1297b75e031ad00f9ebcaa4bd4170b52827c6bc0e87f028ff"
  license "MIT"
  head "https://github.com/amir20/dtop.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "487f402585b7bfc39c44380d862989296db57e1bafaab27e182bc5f6a3a89249"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "401069c9ab760cc6c2b743279aa90a728cd9a23656c63feff36fe10f38219519"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4f9f8979108d71da1571e73296aa048f149cdfaece97aa6bfe2a1e426a11bec"
    sha256 cellar: :any_skip_relocation, sonoma:        "94c182905cd4d5db6f8cbec5d77fbaddac6d9d578549c4727304185db073291e"
    sha256 cellar: :any,                 arm64_linux:   "f3ca8fe781cab08a9651a36534ebadc6e790f77eaab3bb3bdb7da4f1e5068ff9"
    sha256 cellar: :any,                 x86_64_linux:  "89ca8720a05c77f637c071e96728e100665ed42ac8717a0a8fbeadf035fe9062"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dtop --version")

    output = shell_output("#{bin}/dtop 2>&1", 1)
    assert_match "Failed to connect to Docker host", output
  end
end