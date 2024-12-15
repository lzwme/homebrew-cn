class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https:budimanjojo.github.iotalhelperlatest"
  url "https:github.combudimanjojotalhelperarchiverefstagsv3.0.11.tar.gz"
  sha256 "9e6d4285e1bb828462bddc38c003c0f8e871a0147a08518dfffd508f8d4f4dca"
  license "BSD-3-Clause"
  head "https:github.combudimanjojotalhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "20812b67e83ede93c5e209a76be16de12c897e41567ab1d54038ac02a6d213f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20812b67e83ede93c5e209a76be16de12c897e41567ab1d54038ac02a6d213f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20812b67e83ede93c5e209a76be16de12c897e41567ab1d54038ac02a6d213f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "18597594eec42caba8d459bfccb11439be9641acaa833edb4db5717a65507e00"
    sha256 cellar: :any_skip_relocation, ventura:       "18597594eec42caba8d459bfccb11439be9641acaa833edb4db5717a65507e00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0dd35dbda21277f5fc3215fd60224f55fe7a6c7ba15e01cf4076cf2b5b4adf0a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.combudimanjojotalhelperv#{version.major}cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin"talhelper", "completion")
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}example*"], testpath

    output = shell_output("#{bin}talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}talhelper --version")
  end
end