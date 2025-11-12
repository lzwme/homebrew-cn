class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://ghfast.top/https://github.com/alda-lang/alda/archive/refs/tags/release-2.3.5.tar.gz"
  sha256 "0d7babe617ea7e8e20db9cb0e9c95d8631e9d67babdcce73e26ebc545716365e"
  license "EPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55090f02a7885a371d14419e846509d9941a4a3974316789395807fe88ec5654"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe22e245ce2c766bde355e0648ef9f125fdc40eebf29060865b57904010588c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "906227a181d5894cf6284428c961e000a0aff63f658cd466eda4baae7b047f63"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ff69e4d0654de8ce140f362e34767575fdd19523d1fc09e9d0ab0991fa43f12"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c5345ef8760b3ad37cfe80b5157790134d1a8e00fdb6b29311f30d01df3e30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e1e328907176bac96c3c086fe3514474880518d6d2716f079c9af51ca5da642"
  end

  depends_on "go" => :build
  # Issue ref: https://github.com/alda-lang/alda/issues/510
  depends_on "gradle@8" => :build
  depends_on "openjdk"

  def install
    pkgshare.install "examples"
    cd "client" do
      system "go", "generate"
      system "go", "build", *std_go_args
    end
    cd "player" do
      system "gradle", "build"
      libexec.install "build/libs/alda-player-fat.jar"
      bin.write_jar_script libexec/"alda-player-fat.jar", "alda-player"
    end
  end

  test do
    (testpath/"hello.alda").write "piano: c8 d e f g f e d c2."
    json_output = JSON.parse(shell_output("#{bin}/alda parse -f hello.alda 2>/dev/null"))
    midi_notes = json_output["events"].map { |event| event["midi-note"] }
    assert_equal [60, 62, 64, 65, 67, 65, 64, 62, 60], midi_notes
  end
end