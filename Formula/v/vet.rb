class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.12.1.tar.gz"
  sha256 "90924fd77f5266d4d47eb2b7bdb3a9a4e3f726e3d8d22806aab637c4477edb42"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11bdbc2f9ad690c0b565c406416150295f9a40958d81c4b43023339807064391"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b1faa2f513bd146cb2d26026a7d46b9f72e3e049768927b6ef8f998d136624c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6cbf6c7140501d6969b81f88c737b224dbf8f61e2877879943425c1ddf4ff89c"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e48bf8ffc70adff6bbe3e712e46469a7730e5b8008a3263ccd9c4f624add07f"
    sha256 cellar: :any_skip_relocation, ventura:       "a20ebfbf9f30367efbd8c99c228aaa486fa5437ad784155928adc14426729c9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "450da30292f08ad12f80cab515685e58e9976e21e93dce7aa5074c4567222279"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af476e82335592961bd5e8f5ba95e1a74c8207d99ebbc1940fa461a9f24ad15a"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end