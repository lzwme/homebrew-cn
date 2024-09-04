class Ppss < Formula
  desc "Shell script to execute commands in parallel"
  homepage "https:github.comlouwrentiusPPSS"
  url "https:storage.googleapis.comgoogle-code-archive-downloadsv2code.google.comppssppss-2.97.tgz"
  sha256 "25d819a97d8ca04a27907be4bfcc3151712837ea12a671f1a3c9e58bc025360f"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "e341e42c45d8ab9d5251b5330405329c45f1342a2cd94a466764b894a2b9ac6c"
  end

  def install
    bin.install "ppss"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ppss --version")
  end
end