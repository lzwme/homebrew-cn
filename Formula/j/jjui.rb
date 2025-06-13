class Jjui < Formula
  desc "TUI for interacting with the Jujutsu version control system"
  homepage "https:github.comidursunjjui"
  url "https:github.comidursunjjuiarchiverefstagsv0.8.10.tar.gz"
  sha256 "a4c9a20d781e42da4cb44dd198159fdadcabfa37e3caadc5521d3d03a89ea952"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb30b1f45d96ffd713e24aaf4c8d6ccd228a0f4b5ec9d58eea1d14e6622b85d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb30b1f45d96ffd713e24aaf4c8d6ccd228a0f4b5ec9d58eea1d14e6622b85d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8fb30b1f45d96ffd713e24aaf4c8d6ccd228a0f4b5ec9d58eea1d14e6622b85d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e224661471591698b689897369fe054e9fade427b1931b05af178d9f3fe375cc"
    sha256 cellar: :any_skip_relocation, ventura:       "e224661471591698b689897369fe054e9fade427b1931b05af178d9f3fe375cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b6537ef1509cc9f68c8987564cfdc949c8d14f3da2299eaa5390672e7ec33d3"
  end

  depends_on "go" => :build
  depends_on "jj"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), ".cmdjjui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}jjui -version")
    assert_match "Error: There is no jj repo in", shell_output("#{bin}jjui 2>&1", 1)
  end
end