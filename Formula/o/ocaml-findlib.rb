class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http:projects.camlcity.orgprojectsfindlib.html"
  url "http:download.camlcity.orgdownloadfindlib-1.9.8.tar.gz"
  sha256 "662c910f774e9fee3a19c4e057f380581ab2fc4ee52da4761304ac9c31b8869d"
  license "MIT"

  livecheck do
    url "http:download.camlcity.orgdownload"
    regex(href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "03fe6ad50310fb334e8462e6b8aa72bccc4f3dc3b816cccc9835501cec1a0ca5"
    sha256 arm64_sonoma:  "9f321718e1130300b05d42c1aae5b4337a397d00a9349b2b73003398db5f4aed"
    sha256 arm64_ventura: "a2cc4e954175bb2a815514c386e496f0b50c2ffd0f4e673345f0603777c9c165"
    sha256 sonoma:        "0ef0a07bedb9389307abbecd9e69d86b09328f8fbb6038030d01aac1d1aa5134"
    sha256 ventura:       "25ecb43a6a9edea3a10d0b0d98855aca9bca70f5eab85817444a5ab7876f6ebf"
    sha256 x86_64_linux:  "c445c7bfb1517241f733de3fcd90e3e7cda30cebcd163b2e37c31d3ec6e94acf"
  end

  depends_on "ocaml"

  uses_from_macos "m4" => :build

  def install
    # Specify HOMEBREW_PREFIX here so those are the values baked into the compile,
    # rather than the Cellar
    system ".configure", "-bindir", bin,
                          "-mandir", man,
                          "-sitelib", HOMEBREW_PREFIX"libocaml",
                          "-config", etc"findlib.conf",
                          "-no-camlp4"

    system "make", "all"
    system "make", "opt"

    # Override the above paths for the install step only
    system "make", "install", "OCAML_SITELIB=#{lib}ocaml",
                              "OCAML_CORE_STDLIB=#{lib}ocaml"

    # Avoid conflict with ocaml-num package
    rm_r(Dir[lib"ocamlnum", lib"ocamlnum-top"])

    # Save extra findlib.conf to work around https:github.comHomebrewhomebrew-test-botissues805
    libexec.mkpath
    cp etc"findlib.conf", libexec"findlib.conf"
  end

  test do
    output = shell_output("#{bin}ocamlfind query findlib")
    assert_equal "#{HOMEBREW_PREFIX}libocamlfindlib", output.chomp
  end
end