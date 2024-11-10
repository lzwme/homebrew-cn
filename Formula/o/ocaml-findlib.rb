class OcamlFindlib < Formula
  desc "OCaml library manager"
  homepage "http:projects.camlcity.orgprojectsfindlib.html"
  url "http:download.camlcity.orgdownloadfindlib-1.9.7.tar.gz"
  sha256 "ccd822008f1b87abd56a12ff7f4af195a0cda2e3bc0113921779a205c9791e29"
  license "MIT"

  livecheck do
    url "http:download.camlcity.orgdownload"
    regex(href=.*?findlib[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 arm64_sequoia: "eb5b2b68030d3527fd4b2e9c260a944605862909325bc9249b57c890449ad9f0"
    sha256 arm64_sonoma:  "71160fdec707a48d88e6f2e79f38d0df3e970e3fe81141c0da6687bbd1cb2704"
    sha256 arm64_ventura: "82ccb62e19cdbf9c9b581603ddf1a1c8d8ebe5789960df955bd29cf7764f6e09"
    sha256 sonoma:        "fda2c76eff2c5bf058045e51b92663ba21c9b0ba92ffac80d27369cffaff291d"
    sha256 ventura:       "47d5af648254ec365ad4127fd96fb2c5d384f2199963f8ca12d482718875f2f2"
    sha256 x86_64_linux:  "45f892f48a91e37037c44cf98b6937a35a29621993d9c9a54224bead2623c958"
  end

  depends_on "ocaml"

  uses_from_macos "m4" => :build

  # Fix to not null parameter `dynlink_subdir`
  # https:github.comocamlocamlfindissues88
  patch :DATA

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

__END__
diff --git aconfigure bconfigure
index a1ca170..07570c0 100755
--- aconfigure
+++ bconfigure
@@ -502,6 +502,11 @@ check_library () {
         # Library is present - exit code is 0 because the library is found
         # (e.g. detection for Unix) but we don't actually add it to the
         # generated_META list.
+        package_dir="${ocaml_sitelib}$1"
+        package_subdir="$1"
+        package_key="$(echo "$1" | tr - _)"
+        eval "${package_key}_dir=\"${package_dir}\""
+        eval "${package_key}_subdir=\"${package_subdir}\""
         return 0
     fi