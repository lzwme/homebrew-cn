class Pvetui < Formula
  desc "Terminal UI for Proxmox VE"
  homepage "https://github.com/devnullvoid/pvetui"
  url "https://ghfast.top/https://github.com/devnullvoid/pvetui/archive/refs/tags/v1.0.15.tar.gz"
  sha256 "6be2a3937d0e7943d04839f582780cf814323744b06ce96923d2c7725bdd8368"
  license "MIT"
  head "https://github.com/devnullvoid/pvetui.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d4e49ebf349a60d755262aafefff0222630e03675b3988c55ffe5ee2c30c5c5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d4e49ebf349a60d755262aafefff0222630e03675b3988c55ffe5ee2c30c5c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d4e49ebf349a60d755262aafefff0222630e03675b3988c55ffe5ee2c30c5c5"
    sha256 cellar: :any_skip_relocation, sonoma:        "607fbf026e46c5a552db2f8c6a9f0b7348054b8f272f7ef8cb717018687a140f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc8f8affa7c34cf5dfa4e6e015746e9adfb2b398d7a1d4dce2c0e012bd9be60c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "53a0262be9a47091e3ff2a4ddf864c441824f9b4de00c67731025c7a14b9af4d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/devnullvoid/pvetui/internal/version.version=#{version}
      -X github.com/devnullvoid/pvetui/internal/version.commit=#{tap.user}
      -X github.com/devnullvoid/pvetui/internal/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/pvetui"
  end

  test do
    assert_match "It looks like this is your first time running pvetui.", pipe_output(bin/"pvetui", "n")
    assert_match version.to_s, shell_output("#{bin}/pvetui --version")
  end
end