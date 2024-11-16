class Incus < Formula
  desc "CLI client for interacting with Incus"
  homepage "https:linuxcontainers.orgincus"
  url "https:linuxcontainers.orgdownloadsincusincus-6.7.tar.xz"
  sha256 "a2c429142e99b00af5353a6acf8e7d408fc4f4b1925c20a2b58d39a67325332e"
  license "Apache-2.0"
  head "https:github.comlxcincus.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a777bbf236f6836f5bc6f88770564c11970ce1dce14d080e1cba6e48789d752"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a777bbf236f6836f5bc6f88770564c11970ce1dce14d080e1cba6e48789d752"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9a777bbf236f6836f5bc6f88770564c11970ce1dce14d080e1cba6e48789d752"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b09e25e49f7babbce303389ede655af4bce4bc99eaa645b9c2ac923fb4581f4"
    sha256 cellar: :any_skip_relocation, ventura:       "3b09e25e49f7babbce303389ede655af4bce4bc99eaa645b9c2ac923fb4581f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31cce16c44acbd3b8cfe85aeaff329a3897936bdcc096054e913018da398abd7"
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