class Putmail < Formula
  desc "MTA or SMTP client designed to replace the sendmail command"
  homepage "https://putmail.sourceforge.net/home.html"
  url "https://downloads.sourceforge.net/project/putmail/putmail.py/1.4/putmail.py-1.4.tar.bz2"
  sha256 "1f4e6f33496100ad89b8f029621fb78ab2f80258994c7cd8687fd46730df45be"
  license "ICU"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1df81ef382665ba394fb3ee99383dd7662a776290f9efdb0a2c7765ce3a663e4"
  end

  # putmail doesn't support Python 3
  disable! date: "2024-07-03", because: :unsupported

  def install
    bin.install "putmail.py"
    man1.install "man/man1/putmail.py.1"
    bin.install_symlink "putmail.py" => "putmail"
    man1.install_symlink "putmail.py.1" => "putmail.1"
  end
end