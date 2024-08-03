class Rtags < Formula
  desc "Source code cross-referencer like ctags with a clang frontend"
  homepage "https:github.comAndersbakkenrtags"
  license "GPL-3.0-or-later"
  revision 2
  head "https:github.comAndersbakkenrtags.git", branch: "master"

  stable do
    url "https:github.comAndersbakkenrtags.git",
        tag:      "v2.40",
        revision: "8597d6d2adbe11570dab55629ef9a684304ec3cd"

    # fix compiling with gcc 11
    patch do
      url "https:github.comAndersbakkenrctcommit31347b4ff91fa6ea68035e0e7b88ed0330016d7f.patch?full_index=1"
      sha256 "9324dded21b6796e218b0f531ade00cc3b2ef725e00e8296c497db3de47638df"
      directory "srcrct"
    end

    # fix lisp files, remove on release 2.42
    patch do
      url "https:github.comAndersbakkenrtagscommit63f18acb21e664fd92fbc19465f0b5df085b5e93.patch?full_index=1"
      sha256 "3229b2598211b2014a93a2d1e906cccf05b6a8a708234cc54f21803e6e31ef2a"
    end
  end

  # The `strategy` code below can be removed ifwhen this software exceeds
  # version 3.23. Until then, it's used to omit a malformed tag that would
  # always be treated as newest.
  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
    strategy :git do |tags, regex|
      malformed_tags = ["v3.23"].freeze
      tags.map do |tag|
        next if malformed_tags.include?(tag)

        tag[regex, 1]
      end
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "f8b0c6d335f6247c80669d0a7b4c8dc84603bda12f3ee2caf44c49b0df108ebc"
    sha256 cellar: :any, arm64_ventura:  "2ec2449f1dcf791262ee62099508bf16f3f5e8df47903d39c8f193c0964f82ae"
    sha256 cellar: :any, arm64_monterey: "c0add9226d0f17dd7e5af52d971bfc2cc34fd8ac287e4d10f74ab58943707e0b"
    sha256 cellar: :any, arm64_big_sur:  "433d1b112af6c1ce683cb70e4db8bf88f3e44ec8751b6e661cf48f7b5f8fbb42"
    sha256 cellar: :any, sonoma:         "c813c8d0a9888971145b2474e74189e557fa18983c3e740d0845e4744be8ac8a"
    sha256 cellar: :any, ventura:        "cc469412590ba876a5e613cbe8262af7288bde3afb390c2cf297c3267a0b3cab"
    sha256 cellar: :any, monterey:       "99dc03192ec0a84923f9bf8fe19ad3d1395726bceb0d49295dc1ecb9109f7146"
    sha256 cellar: :any, big_sur:        "5f59e2fe69f4fb60cf4f5517908f80998553fa0b9de2f9b7536a5740e7fffddb"
    sha256               x86_64_linux:   "829f4a0e89e3fd837f0baa3ca0ab05244c7705222d9e75a2b81f2349390d4d64"
  end

  depends_on "cmake" => :build
  depends_on "emacs"
  depends_on "llvm"
  depends_on "openssl@3"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DRTAGS_NO_BUILD_CLANG=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [opt_bin"rdm", "--verbose", "--inactivity-timeout=300"]
    keep_alive true
    log_path var"logrtags.log"
    error_log_path var"logrtags.log"
  end

  test do
    mkpath testpath"src"
    (testpath"srcfoo.c").write <<~EOS
      void zaphod() {
      }

      void beeblebrox() {
        zaphod();
      }
    EOS
    (testpath"srcREADME").write <<~EOS
      42
    EOS

    rdm = fork do
      $stdout.reopen("devnull")
      $stderr.reopen("devnull")
      exec "#{bin}rdm", "--exclude-filter=\"\"", "-L", "log"
    end

    begin
      sleep 1
      pipe_output("#{bin}rc -c", "clang -c #{testpath}srcfoo.c", 0)
      sleep 1
      assert_match "foo.c:1:6", shell_output("#{bin}rc -f #{testpath}srcfoo.c:5:3")
      system bin"rc", "-q"
    ensure
      Process.kill 9, rdm
      Process.wait rdm
    end
  end
end