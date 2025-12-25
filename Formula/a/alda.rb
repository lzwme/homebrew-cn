class Alda < Formula
  desc "Music programming language for musicians"
  homepage "https://alda.io"
  url "https://ghfast.top/https://github.com/alda-lang/alda/archive/refs/tags/release-2.3.5.tar.gz"
  sha256 "0d7babe617ea7e8e20db9cb0e9c95d8631e9d67babdcce73e26ebc545716365e"
  license "EPL-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c52d9712b56d6b16154e7ebd6639357f51f0538f29d6f4c703ed250e42640b69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8dc776d100206ee4e95ebb38ece200560baab2be2b14bf41b8d7c7fd6c8ac071"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20f9d335f847f676eb067adf7c49ac56d12cd368cbca0854f5ca14836ef3eed1"
    sha256 cellar: :any_skip_relocation, sonoma:        "8e0070e1fa979f5c780a21f33c2681e7ebd942abcd2d41d5504124d4d8c47e6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95a2020222030a53e7c6ebd84c92f828878a90a6896227d3c303cf4bf2822649"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e6d7f350cd08653e637cd933924a3b11a6ddd7277148e705a30e674ed637763"
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

    generate_completions_from_executable(bin/"alda", shell_parameter_format: :cobra)
  end

  test do
    (testpath/"hello.alda").write "piano: c8 d e f g f e d c2."
    json_output = JSON.parse(shell_output("#{bin}/alda parse -f hello.alda 2>/dev/null"))
    midi_notes = json_output["events"].map { |event| event["midi-note"] }
    assert_equal [60, 62, 64, 65, 67, 65, 64, 62, 60], midi_notes
  end
end