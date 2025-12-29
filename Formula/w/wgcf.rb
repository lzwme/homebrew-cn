class Wgcf < Formula
  desc "Generate WireGuard profile from Cloudflare Warp account"
  homepage "https://github.com/ViRb3/wgcf"
  url "https://ghfast.top/https://github.com/ViRb3/wgcf/archive/refs/tags/v2.2.29.tar.gz"
  sha256 "25bd436c3d0919c8e76a2e31806520c401c9561663946951746d4027a7fab96a"
  license "MIT"
  head "https://github.com/ViRb3/wgcf.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9adcc8bf972aaa8df188ecbd7e7063fd6c1c7c5a48329d621101c90b72044f7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9adcc8bf972aaa8df188ecbd7e7063fd6c1c7c5a48329d621101c90b72044f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9adcc8bf972aaa8df188ecbd7e7063fd6c1c7c5a48329d621101c90b72044f7"
    sha256 cellar: :any_skip_relocation, sonoma:        "8831843b37878ac2c9be55e77cbc9a0ece6eb0f42e3bc24f42502df75caebdc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16c0287850880581b36ca81efa48b9eb2adc01bc5d029e9697b19963a091b4c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3890d93b2ee62f417566b021fa9affd15a59417e8bf1a6d66e6f106a55c5ee53"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"wgcf", shell_parameter_format: :cobra)
  end

  test do
    system bin/"wgcf", "trace"
  end
end