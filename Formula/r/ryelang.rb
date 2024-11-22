class Ryelang < Formula
  desc "Rye is a homoiconic programming language focused on fluid expressions"
  homepage "https:ryelang.org"
  url "https:github.comrefaktorryearchiverefstagsv0.0.31.tar.gz"
  sha256 "64aa0a30d7fb1e764a81c3ec1b9b2610e836d33616eb38d8286ff53fbcf17fd8"
  license "Apache-2.0"
  head "https:github.comrefaktorrye.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d060f4069060f18d2b1a49217911ca37c2aec1f510f87fdfb47552149ee3afec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "190486668432874760042b126f75eaf9ea29628d2282280a8c87e5dd3638407a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9e81b8793cd969279c8e578a3d868aea8da315d16c3f0351e205f59188dcaa71"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea5d5e389daf8c7130109acf0ab428335588e2d3632dd0d5a6dc08874a96e21c"
    sha256 cellar: :any_skip_relocation, ventura:       "58fba0576987b7e91cf90628d89395010a8ecab479161822e7d5ec8b929341fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ecd66840369f138cd8437f8634ce09974e83b0a883ea8e5b465b5464551c546"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath"hello.rye").write <<~EOS
      "Hello World" .replace "World" "Mars" |print
      "12 8 12 16 8 6" .load .unique .sum |print
    EOS
    assert_predicate testpath"hello.rye", :exist?
    output = shell_output("#{bin}ryelang hello.rye 2>&1")
    assert_equal "Hello Mars\n42", output.strip
  end
end