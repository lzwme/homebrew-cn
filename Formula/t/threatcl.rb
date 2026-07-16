class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "d59afe8cae1c8152203a79bb2749be6aaf8011f889f22d664374409cb30a7dfe"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "be6bf58b88e1c8b798781599b9526b16055fa19603f37032d26739d8a614b4eb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be6bf58b88e1c8b798781599b9526b16055fa19603f37032d26739d8a614b4eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be6bf58b88e1c8b798781599b9526b16055fa19603f37032d26739d8a614b4eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2ab9d00cab9c9574c44fe32ec989e19d42f5f18582a9bec4bf68cf65d2ad033a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2a55f6a1f09a756e1cd0d2a42e589d2581141b54be644fcaf53a5d26f0a33250"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "db40006f0e55cc9084b35c2e0e291529608fd07e2212cb8c64c36e80e78c45d7"
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