class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://ghfast.top/https://github.com/safedep/vet/archive/refs/tags/v1.12.15.tar.gz"
  sha256 "2d4338a904d2e1d01c328773dc3f0003bb8f4b0c376db7dc64b45e5dc3b0ff27"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "93c2688688fd3ddfe1dfdfe809954c48673e8ba6591b8b0e33a5b5d886c5fdb2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13ddd6a66142cc3f008fcd8cd6d8149ee684a879f82823b35679fa32789a07c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "11eecedf6a4d79f92dc11c1d6b5ea198ad3a3f856d0125957db1bd8472f68f45"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9b437509e1f4ad6f9be3bd4fc5ddbb1d4af3bc4c5a238c006e05594d58b4c2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de09bc83c6403bfe201b344c51b1b917f1562e5a7d0588b21730183f5d790e0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "54363f4ba956236cbb54da75820a1ba3796c165fe6e84eecfab02ca89e0bc223"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
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