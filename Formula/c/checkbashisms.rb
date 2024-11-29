class Checkbashisms < Formula
  desc "Checks for bashisms in shell scripts"
  homepage "https://launchpad.net/ubuntu/+source/devscripts/"
  url "https://deb.debian.org/debian/pool/main/d/devscripts/devscripts_2.24.5.tar.xz"
  sha256 "4d7abb27cd3f3f5017dc001ec7371673ccfb52440b1ed24268334bb469941248"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://deb.debian.org/debian/pool/main/d/devscripts/"
    regex(/href=.*?devscripts[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4884e83f9896e2394bb971ca1975ad6fc8b578c6af34262493a166ae7101e3a5"
  end

  def install
    inreplace "scripts/checkbashisms.pl" do |s|
      s.gsub! "###VERSION###", version.to_s
      s.gsub! "#!/usr/bin/perl", "#!/usr/bin/perl -T"
    end

    bin.install "scripts/checkbashisms.pl" => "checkbashisms"
    man1.install "scripts/checkbashisms.1"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      #!/bin/sh

      if [[ "home == brew" ]]; then
        echo "dog"
      fi
    SHELL
    expected = <<~EOS
      (alternative test command ([[ foo ]] should be [ foo ])):
    EOS
    assert_match expected, shell_output("#{bin}/checkbashisms #{testpath}/test.sh 2>&1", 1)
  end
end