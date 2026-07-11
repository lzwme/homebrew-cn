class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://ghfast.top/https://github.com/threatcl/threatcl/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "355820b9a82dbe4087a16fe5acc0fd3df9036ec503045e0ba171565ae156061e"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "60ece4eb67bb6efd9c4b2b062d96336241857652825d958670c95c9d50b4da91"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60ece4eb67bb6efd9c4b2b062d96336241857652825d958670c95c9d50b4da91"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60ece4eb67bb6efd9c4b2b062d96336241857652825d958670c95c9d50b4da91"
    sha256 cellar: :any_skip_relocation, sonoma:        "24877f6dac6aefb4de2bdebef68d1f4b318ad0caeff988e6a047c5dd19ff9a31"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2abce7065594c5fb89f92657549455aac7ed96a3f2de3fc97d845d1de6040c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "44595149b607c9e91a832684525a03eb09ce0db023651a2ac3aa0067b1bffb41"
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