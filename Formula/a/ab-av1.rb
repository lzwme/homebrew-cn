class AbAv1 < Formula
  desc "AV1 re-encoding using ffmpeg, svt-av1 & vmaf"
  homepage "https:github.comalexhereticab-av1"
  url "https:github.comalexhereticab-av1archiverefstagsv0.9.2.tar.gz"
  sha256 "9f5926f9e11c1d7ad86d9c993fbf2bed00bc64e3710cba16f89dca706eceea55"
  license "MIT"
  head "https:github.comalexhereticab-av1.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eb6575659db45c41b513d1501402ea133a567f4d313bc12f1564e6f8e0c8872c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81265d1f80b4c66a6d638ccde86115f597d53cb8b30d18ce57e99bedff30a0f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a0f29a5e3f2cf738a56f972bde4630a6a7785d16c8140060b85395ba0c09172d"
    sha256 cellar: :any_skip_relocation, sonoma:        "138996029202461b5a53ca6be0e1f6bf27d2e7aa8e31a49c69c2036412ed3e87"
    sha256 cellar: :any_skip_relocation, ventura:       "b63035f379c8907b750c2a21e01dd59d25b07bdd045a799f5459be73be0d8167"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba12601b3ae443186290445556655b42be739944c1c9bdfb0cce8268316bbe96"
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