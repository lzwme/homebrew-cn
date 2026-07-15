class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.1.tar.gz"
  sha256 "eb4fa3bcf96c17d6e28d5ee049280abfdca49a891c3faa6dfc2f6710c087c7d1"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba98ce10ab9a17870f8045f8af476d6beac724e25f103d441f2304e2ae5e1a19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba98ce10ab9a17870f8045f8af476d6beac724e25f103d441f2304e2ae5e1a19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba98ce10ab9a17870f8045f8af476d6beac724e25f103d441f2304e2ae5e1a19"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9836c4807a66228e60c36b1a0f3fee3b5ee684467ccaea6ff05634d2b1523b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7fc8db19d1424df824e4237e44b05bd01591cccabac7f159f4870d31de426345"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1cdc9a24b7c7d0421b84aa1fe5826ca6e4b327a21b93a590e90e4c5591d2892"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = "-s -w -X github.com/threatcl/threatcl/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    # Other examples remote-import files that need `allow_remote_imports`
    cp pkgshare/"examples/tm1.hcl", testpath

    assert_match "Tower of London", shell_output("#{bin}/threatcl list #{testpath}/tm1.hcl")
    assert_match "Validated 2 threatmodels", shell_output("#{bin}/threatcl validate #{testpath}/tm1.hcl")
    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end