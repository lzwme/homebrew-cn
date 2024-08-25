class Fisher < Formula
  desc "Plugin manager for the Fish shell"
  homepage "https:github.comjorgebucaranfisher"
  url "https:github.comjorgebucaranfisherarchiverefstags4.4.4.tar.gz"
  sha256 "856e490e35cb9b1f1f02d54c77c6f4e86eb6f97fb5cfd8883a9df7b1d148a8e6"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "92aaf66b6b254cbadbe37daaa48f46bac68b2cbfca3a510fbbcbafa21f0027cf"
  end

  depends_on "fish"

  def install
    fish_function.install "functionsfisher.fish"
    fish_completion.install "completionsfisher.fish"
  end

  test do
    system "#{Formula["fish"].bin}fish", "-c", "fisher install jethrokuanz"
    assert_equal File.read(testpath".configfishfish_plugins"), "jethrokuanz\n"
  end
end