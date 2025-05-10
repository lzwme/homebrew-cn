class Yeet < Formula
  desc "Packaging tool that lets you declare build instructions in JavaScript"
  homepage "https:github.comTecharoHQyeet"
  url "https:github.comTecharoHQyeetarchiverefstagsv0.2.3.tar.gz"
  sha256 "007121e2b511193f861284d3a156756639c8d9a80d7404ac97058f8054bb67c2"
  license "MIT"
  head "https:github.comTecharoHQyeet.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c5c7b51cb1a6a0ecc7ceac5383389d43cc5efe3c3a0073c3595caebd521ec3b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c5c7b51cb1a6a0ecc7ceac5383389d43cc5efe3c3a0073c3595caebd521ec3b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c5c7b51cb1a6a0ecc7ceac5383389d43cc5efe3c3a0073c3595caebd521ec3b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a998adc097bc329fd3bd943c45d4db704fa76e711bb6c756800949cf01d2d3b"
    sha256 cellar: :any_skip_relocation, ventura:       "9a998adc097bc329fd3bd943c45d4db704fa76e711bb6c756800949cf01d2d3b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ede85ca1fb1d6f56e81fe34062aa9ba732fb2b57dd4b8092bf4a10b13774729b"
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