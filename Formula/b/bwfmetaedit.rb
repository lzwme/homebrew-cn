class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/26.08/BWFMetaEdit_CLI_26.08_GNU_FromSource.tar.xz"
  sha256 "de5e588d640110a8b26efbc617863664bfd64805fb8beb6520d6bde778ce3a87"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5bc4f17ec5e00dba07053e86ca687eae41f152e60bdaab77fe9c37ba187c570"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f5a57cecc532bace521f2b2f28f238bbbd96304ee8e0d5faf75593f4d56348d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea9834959da8bb6fc8a4ac4f375c43178dedadd0711d8de61f4603f3b4d2af33"
    sha256 cellar: :any,                 arm64_linux:   "d6821ea708082d3b5f8087b5e380eeaa3191abb61a77c0da35b021ea98f97dce"
    sha256 cellar: :any,                 x86_64_linux:  "3616f1e3d7797073934ac6033279606b663cec59a1ba7079f68f281bdfd69f15"
  end

  def install
    cd "Project/GNU/CLI" do
      system "./configure", "--disable-debug", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    test_wav = test_fixtures("test.wav")
    output = shell_output("#{bin}/bwfmetaedit --out-tech #{test_wav} 2>&1", 1)
    assert_match "FileName,FileSize,DateCreated,DateModified,Format,CodecID,Channels,SampleRate,BitRate", output
    assert_match "#{test_wav}: Is read only", output
  end
end