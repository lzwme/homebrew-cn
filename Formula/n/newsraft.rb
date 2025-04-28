class Newsraft < Formula
  desc "Terminal feed reader"
  homepage "https://codeberg.org/newsraft/newsraft"
  url "https://codeberg.org/newsraft/newsraft/archive/newsraft-0.29.tar.gz"
  sha256 "1dbec925d5556cae70e92dcc7b69cc4899473deb1d26a600b8903dbc0b3fde65"
  license "ISC"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "70231c139dd6dd3fafc619285bfcf1267b7884890e8710eedc024aad04ebadf2"
    sha256 cellar: :any,                 arm64_sonoma:  "24ec4ddc7033fff4b00d66669826287545ee2e706b3ba6e2f49ebaffdc4a73de"
    sha256 cellar: :any,                 arm64_ventura: "7a43b1f4de9f8336d1ae341379973194fcb20190fec944cf82803a05239ba907"
    sha256 cellar: :any,                 sonoma:        "a08c905dcca181c8d6f4b152f1affa9f8ab95c5f86d89afc2ed816a389d0804e"
    sha256 cellar: :any,                 ventura:       "19ec74fd129425f061fac099cabad6242758e263f872486743bff5b1a476caaa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b940bbce47ca977559790c16a354d54bab562c19c2aeb995af1926558496fc58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4b7091f5e434a555cb3c21ff946ea84ee7a41570f0ca3a6e6010c55e4e87b6b2"
  end

  depends_on "scdoc" => :build
  depends_on "gumbo-parser"
  depends_on "ncurses"
  depends_on "yajl"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "sqlite"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/newsraft -v 2>&1")

    system "#{bin}/newsraft -l test 2>&1 || :"
    assert_match "Trying to initialize curses library...", File.read("test")
  end
end