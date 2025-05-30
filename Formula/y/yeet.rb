class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https:github.comTecharoHQyeet"
  url "https:github.comTecharoHQyeetarchiverefstagsv0.4.0.tar.gz"
  sha256 "9928c0ed6656b21acb15c47c4bfd9ed82c14eaa0d626a9d0f3c17afd067b9a95"
  license "MIT"
  head "https:github.comTecharoHQyeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "581f6c91c29b075efd137b64eeb72d1d94d85debb562f97a062b37e554602a2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "581f6c91c29b075efd137b64eeb72d1d94d85debb562f97a062b37e554602a2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "581f6c91c29b075efd137b64eeb72d1d94d85debb562f97a062b37e554602a2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "23db5e623efe63f6dc69f14f13453567fcd2b481a9f5201993b8dd35c2406573"
    sha256 cellar: :any_skip_relocation, ventura:       "23db5e623efe63f6dc69f14f13453567fcd2b481a9f5201993b8dd35c2406573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4909eb48b1ab44fcfc096dd1ee1655d23d08f9dc26c729a2e62d82744d151573"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comTecharoHQyeet.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdyeet"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}yeet -version")

    output = "open yeetfile.js: no such file or directory"
    assert_match output, shell_output("#{bin}yeet 2>&1", 1)
  end
end