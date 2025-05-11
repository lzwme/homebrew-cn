class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https:github.comalexhereticab-av1"
  url "https:github.comalexhereticab-av1archiverefstagsv0.10.0.tar.gz"
  sha256 "39f952847a7b57b0ad02f8c479ffcdc6de3fb86155375d2b0c3b5a14a212159f"
  license "MIT"
  head "https:github.comalexhereticab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "060f38701c12fb3076daa6c3650b5f076a0a791cccdd8e2f918e782309107bb2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "963a43238b7e963d22df60b7ca760d7d83e4f9458a4d004d5555845ae457be7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "57cc5515ec491fedb516b354bad3f922ce88d650f75859f55c0feb1686f5221d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ed32713e6a9fb378df42d26926080019a48247b51aa94079012b085d6bd3581"
    sha256 cellar: :any_skip_relocation, ventura:       "4f8320d095c6c437a01250cca9c25d90282ca14a58e7bb16da779aba41c2104e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1656f532d63538b01625323b25e6c511e496d70af2ea51d4c0a0b5812eb0187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d1e08da32e54b4834d8983cd04761f47fed58302d278001ff0b718009ac7dc8"
  end

  depends_on "rust" => :build
  depends_on "ffmpeg"

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"ab-av1", "print-completions", shells: [:bash, :zsh])
  end

  test do
    resource "sample-mp4" do
      url "https:download.samplelib.commp4sample-5s.mp4"
      sha256 "05bd857af7f70bf51b6aac1144046973bf3325c9101a554bc27dc9607dbbd8f5"
    end

    assert_match "ab-av1 #{version}", shell_output("#{bin}ab-av1 --version")

    resource("sample-mp4").stage testpath
    system bin"ab-av1", "auto-encode", "-i", testpath"sample-5s.mp4"
    assert_path_exists testpath"sample-5s.av1.mp4"
  end
end