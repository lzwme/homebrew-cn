class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https:docs.kosli.comclient_reference"
  url "https:github.comkosli-devcliarchiverefstagsv2.10.9.tar.gz"
  sha256 "68d3a19d4b2d187b705d6393be1e774ea1a5d85bac5e879be90d4ed11d2b7f31"
  license "MIT"
  head "https:github.comkosli-devcli.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c76a5522f5c246671a3fdfcb0c45c071b33a17c71052fd1f2f9ebc87cc8d733d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7c3a5b3bb9727dc75c4c220f2a359cf0e126c98f7e8cf51974af787dcf96c23"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87d21e5717386269b66e486d0e0c9d0d7c3c6165372e7411eaa31bd2f23ddbe6"
    sha256 cellar: :any_skip_relocation, sonoma:         "40de5daad262cc37139c682bdfc203e7a06978673731c055f8ba258c0e43de3e"
    sha256 cellar: :any_skip_relocation, ventura:        "ad46b9797edbf9f9330e3a1b9540f627b6fac7267cc827ea026e75fa8a9a76d4"
    sha256 cellar: :any_skip_relocation, monterey:       "ade6dcb5ac4be77b5bda08e3024aadfdf855ce1749e974cb5316ac8c9167be98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4129d0dec4bcc092c6484369c5c4444b3c6c06f18d264777ff0ba080842e921c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkosli-devcliinternalversion.version=#{version}
      -X github.comkosli-devcliinternalversion.gitCommit=#{tap.user}
      -X github.comkosli-devcliinternalversion.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin"kosli", ldflags:), ".cmdkosli"

    generate_completions_from_executable(bin"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kosli version")

    assert_match "OK", shell_output("#{bin}kosli status")
  end
end