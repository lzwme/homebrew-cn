class Eprover < Formula
  desc "Theorem prover for full first-order logic with equality"
  homepage "https://eprover.org/"
  url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/V_3.0/E.tgz"
  sha256 "8a7b229eb8aa4ef1dfd14951f51d6229fb19c431bf56c31b46ea361402fccdf9"
  license any_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  livecheck do
    url "https://wwwlehre.dhbw-stuttgart.de/~sschulz/WORK/E_DOWNLOAD/"
    regex(%r{href=.*?V?[._-]?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d27b54edf4fcfcb678c7948e0c90615ccbe4e04b909beada2bc26459ff88b8c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82bbeb6a99ad2ee81a87d6d4c6414ee0e61890941da6f26a831536d10f84e91d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5d6e193b7558437cd79dae86094d573214f90257345b956ac0d8ada5d9e9eba"
    sha256 cellar: :any_skip_relocation, sonoma:         "072889b72ea3087de5e169ea8d6e5cd6eb92f1fda102dd6f2d7950d1b4c8a345"
    sha256 cellar: :any_skip_relocation, ventura:        "9761629088a3cca1a04dcb66a609e3e66ac17779f6bae56a922867cfbf3f7900"
    sha256 cellar: :any_skip_relocation, monterey:       "f120fb627a57eb9371c89f7054c103af01dc945e3da850ad0931d47e347a7f46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0176c21e2abc754a765a859b5ba22db9393bd5590293a08bb94e3612747ca557"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--man-prefix=#{man1}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/eprover", "--help"
  end
end