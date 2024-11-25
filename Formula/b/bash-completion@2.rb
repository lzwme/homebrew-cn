class BashCompletionAT2 < Formula
  desc "Programmable completion for Bash 4.2+"
  homepage "https:github.comscopbash-completion"
  url "https:github.comscopbash-completionreleasesdownload2.15.0bash-completion-2.15.0.tar.xz"
  sha256 "976a62ee6226970283cda85ecb9c7a4a88f62574c0a6f9e856126976decf1a06"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf91eafe8baacf4dc09a22d1fefe219f90479025937d073377f625320a78a5ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf91eafe8baacf4dc09a22d1fefe219f90479025937d073377f625320a78a5ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bf91eafe8baacf4dc09a22d1fefe219f90479025937d073377f625320a78a5ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a13ee70befd5ebe48d5cf1c9d90549eb54f09496e8aae8b2e7ef1a09e58e152"
    sha256 cellar: :any_skip_relocation, ventura:       "5a13ee70befd5ebe48d5cf1c9d90549eb54f09496e8aae8b2e7ef1a09e58e152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf91eafe8baacf4dc09a22d1fefe219f90479025937d073377f625320a78a5ab"
  end

  head do
    url "https:github.comscopbash-completion.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "bash"

  conflicts_with "bash-completion",
    because: "each are different versions of the same formula"

  def install
    inreplace "bash_completion" do |s|
      # `usrbinreadlink -f` exists since macOS 12.3. Older systems
      # (including earlier Monterey releases) do not support this option.
      s.gsub! "readlink -f", "readlink" if OS.mac? && MacOS.version <= :monterey
      # Automatically read Homebrew's existing v1 completions
      s.gsub! "(etcbash_completion.d)", "(#{etc}bash_completion.d)"
    end

    system "autoreconf", "-i" if build.head?
    system ".configure", "--prefix=#{prefix}"
    ENV.deparallelize
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your ~.bash_profile:
        [[ -r "#{etc}profile.dbash_completion.sh" ]] && . "#{etc}profile.dbash_completion.sh"
    EOS
  end

  test do
    system "test", "-f", "#{share}bash-completionbash_completion"
  end
end