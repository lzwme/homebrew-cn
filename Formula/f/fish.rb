class Fish < Formula
  desc "User-friendly command-line shell for UNIX-like operating systems"
  homepage "https://fishshell.com"
  url "https://ghfast.top/https://github.com/fish-shell/fish-shell/releases/download/4.9.2/fish-4.9.2.tar.xz"
  sha256 "26b95769ce17a8962b220ba3f20771117dbfe9cb2c3ba6f4ed139e0cbfdf02b1"
  license "GPL-2.0-only"
  compatibility_version 1
  head "https://github.com/fish-shell/fish-shell.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  pour_bottle? only_if: :default_prefix

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3eedf643000a60e8929585d9217a867fc4c81ab733363ced816c477eb0f25ab1"
    sha256 cellar: :any, arm64_sequoia: "3c9d78db0b6398271529b63453c92d8109e77ea49f7660a15cbf92f6759a59f2"
    sha256 cellar: :any, arm64_sonoma:  "0954783203b4ebbac82edd8c461a0704aab1478938d7caa691435ae17dd10429"
    sha256 cellar: :any, arm64_linux:   "36573583fa8dbddb607d6ef8aafc250813f385a0554733ca610f0e260283bd7d"
    sha256 cellar: :any, x86_64_linux:  "c9a152a339203f6c1a976b9a4d9183a28e154433cc8b0aad4c291ba1046fa203"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "sphinx-doc" => :build
  depends_on "pcre2"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}",
                    "-DWITH_DOCS=ON",
                    "-Dextra_functionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d",
                    "-Dextra_completionsdir=#{HOMEBREW_PREFIX}/share/fish/vendor_completions.d",
                    "-Dextra_confdir=#{HOMEBREW_PREFIX}/share/fish/vendor_conf.d"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"fish", "-c", "echo"
    output = shell_output("#{bin}/fish -c 'set --show fish_function_path'")
    assert_match "#{HOMEBREW_PREFIX}/share/fish/vendor_functions.d", output
  end
end