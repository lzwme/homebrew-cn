class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.2+"
  homepage "https://github.com/scop/bash-completion"
  url "https://ghproxy.com/https://github.com/scop/bash-completion/releases/download/2.11/bash-completion-2.11.tar.xz"
  sha256 "73a8894bad94dee83ab468fa09f628daffd567e8bef1a24277f1e9a0daf911ac"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2327d8eb7f1d32238624d720bd28856c4489fc1992bf3dc48c4a837cb988dfc1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2327d8eb7f1d32238624d720bd28856c4489fc1992bf3dc48c4a837cb988dfc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2327d8eb7f1d32238624d720bd28856c4489fc1992bf3dc48c4a837cb988dfc1"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0a9d02cb41f262b764f79135ba150948faab51058d20030e118b555b50f0f66"
    sha256 cellar: :any_skip_relocation, ventura:        "e0a9d02cb41f262b764f79135ba150948faab51058d20030e118b555b50f0f66"
    sha256 cellar: :any_skip_relocation, monterey:       "e0a9d02cb41f262b764f79135ba150948faab51058d20030e118b555b50f0f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac195162fd4c749460be5eada9042bca58d30646f3eff1371af50cb1fde5714c"
  end

  head do
    url "https://github.com/scop/bash-completion.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bash"

  conflicts_with "bash-completion",
    because: "each are different versions of the same formula"

  def install
    inreplace "bash_completion" do |s|
      s.gsub! "readlink -f", "readlink" if OS.mac?
      if build.head?
        s.gsub! "(/etc/bash_completion.d)", "(#{etc}/bash_completion.d)"
      else
        # Automatically read Homebrew's existing v1 completions
        s.gsub! ":-/etc/bash_completion.d", ":-#{etc}/bash_completion.d"
        # Automatically read Homebrew's v2 completions.
        # TODO: Remove in the next release as script is able to find via PATH.
        s.gsub! ":-/usr/local/share:", ":-#{HOMEBREW_PREFIX}/share:/usr/local/share:"
      end
    end

    system "autoreconf", "-i" if build.head?
    system "./configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your ~/.bash_profile:
        [[ -r "#{etc}/profile.d/bash_completion.sh" ]] && . "#{etc}/profile.d/bash_completion.sh"
    EOS
  end

  test do
    system "test", "-f", "#{share}/bash-completion/bash_completion"
  end
end