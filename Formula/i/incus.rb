class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https:linuxcontainers.orgincus"
  url "https:linuxcontainers.orgdownloadsincusincus-6.4.tar.xz"
  sha256 "6748a61f4a066bcd807c38ca13693f7ede1903d9b44825f1b5bcea4220edeee7"
  license "Apache-2.0"
  head "https:github.comlxcincus.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9f4182d138a3c690323cd3a41c918adc74070bff430fec89c3982ae90299c9a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f4182d138a3c690323cd3a41c918adc74070bff430fec89c3982ae90299c9a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9f4182d138a3c690323cd3a41c918adc74070bff430fec89c3982ae90299c9a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "3655349c15f631735c5354ffbf8a81d16a2efa22f7d13028eea5646b2ac75786"
    sha256 cellar: :any_skip_relocation, ventura:        "3655349c15f631735c5354ffbf8a81d16a2efa22f7d13028eea5646b2ac75786"
    sha256 cellar: :any_skip_relocation, monterey:       "3655349c15f631735c5354ffbf8a81d16a2efa22f7d13028eea5646b2ac75786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7949a48b1091acd47f41d0e2c29e7c57f491c7845bd90cb7d5f96d26aaf9696a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdincus"

    generate_completions_from_executable(bin"incus", "completion")
  end

  test do
    output = JSON.parse(shell_output("#{bin}incus remote list --format json"))
    assert_equal "https:images.linuxcontainers.org", output["images"]["Addr"]

    assert_match version.to_s, shell_output("#{bin}incus --version")
  end
end