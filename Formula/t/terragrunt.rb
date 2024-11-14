class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https:terragrunt.gruntwork.io"
  url "https:github.comgruntwork-ioterragruntarchiverefstagsv0.68.13.tar.gz"
  sha256 "5dbdbc7128c6724361baf371a70d525306bcd46cc82f266d2f3ae8313ada473f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c6f779d3dab9a3cee63d704c740981b511c05d352ac22fc1fd5b3c491a23989"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c6f779d3dab9a3cee63d704c740981b511c05d352ac22fc1fd5b3c491a23989"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c6f779d3dab9a3cee63d704c740981b511c05d352ac22fc1fd5b3c491a23989"
    sha256 cellar: :any_skip_relocation, sonoma:        "5114561c4cc36b2720e1e32e7c4c5dbf9f307a4ade153a0a7b857c46bc305774"
    sha256 cellar: :any_skip_relocation, ventura:       "5114561c4cc36b2720e1e32e7c4c5dbf9f307a4ade153a0a7b857c46bc305774"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c9dc18d55591366021b2d5e7f3d9518e07bf69d9883ff3b0cbfd2959b437520"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.comgruntwork-iogo-commonsversion.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}terragrunt --version")
  end
end