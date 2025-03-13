class Asdf < Formula
  desc "Extendable version manager with support for Ruby, Node.js, Erlang & more"
  homepage "https:asdf-vm.com"
  url "https:github.comasdf-vmasdfarchiverefstagsv0.16.5.tar.gz"
  sha256 "d7b6e1efcdd62c881c7f4a539ce3a56131d9ddcbcc13e8099ee371545d38706a"
  license "MIT"
  head "https:github.comasdf-vmasdf.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "90346d0b6c2cb065be3deee9dc0b0e4c903984a9f047ba7c481020efbe9f368a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90346d0b6c2cb065be3deee9dc0b0e4c903984a9f047ba7c481020efbe9f368a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "90346d0b6c2cb065be3deee9dc0b0e4c903984a9f047ba7c481020efbe9f368a"
    sha256 cellar: :any_skip_relocation, sonoma:        "29933f1ae2ea276c92d7a22df8aa27ce74863d9889e76b361d5eff9424861997"
    sha256 cellar: :any_skip_relocation, ventura:       "29933f1ae2ea276c92d7a22df8aa27ce74863d9889e76b361d5eff9424861997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e4548068a801b520156702ed76fb907b80e9f0518151a89b9b724b62cfdfda2"
  end

  depends_on "go" => :build

  def install
    # fix https:github.comasdf-vmasdfissues1992
    # relates to https:github.comHomebrewhomebrew-coreissues163826
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), ".cmdasdf"
    generate_completions_from_executable(bin"asdf", "completion")
    libexec.install Dir["asdf.*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}asdf version")
    assert_match "No plugins installed", shell_output("#{bin}asdf plugin list 2>&1")
  end
end