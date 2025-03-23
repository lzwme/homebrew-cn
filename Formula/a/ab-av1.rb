class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https:github.comalexhereticab-av1"
  url "https:github.comalexhereticab-av1archiverefstagsv0.9.3.tar.gz"
  sha256 "bd1b16ead392a58dfe7851d872e9296ffe63a15940fcee62a60e804596186e4e"
  license "MIT"
  head "https:github.comalexhereticab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "369e78e67daf8c152e0056759b705c3846b2275057c2efc598b89a46a0d4b550"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0df51a681c8acc463b4dd5462686e94057fa9bd9431b30a090c375f8563af3e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a37bd68b59b2c45360a4c0f98cb7576724721b5da8e5edb741580af9162a2c2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "b218932b4ac28bb9d37643bd9d9e178268e5ffe1ae3bbd35d3db8bc569c6cdef"
    sha256 cellar: :any_skip_relocation, ventura:       "5cc90e3553454c11c1538c2a19248feca6edae9047268863c2f27331cd7d3998"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c63a0659214937348c490038c52a08174cfa5844967081e5250c1d7cbc5fe76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "697001bcb02b52018af6b8e45eca402d141136cacfc8a4cfbbab5d6f69dd1f64"
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