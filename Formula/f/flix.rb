class Flix < Formula
  desc "Statically typed functional, imperative, and logic programming language"
  homepage "https://flix.dev/"
  url "https://ghfast.top/https://github.com/flix/flix/archive/refs/tags/v0.75.0.tar.gz"
  sha256 "ae72bba3cbf25a5994ace8c20513f3e5951e4626dcd58971db11e0cb087a1677"
  license "Apache-2.0"
  head "https://github.com/flix/flix.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?\.?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dab9b244660324c776296d5b61f98b4b6c73ea99588e38db4e2aa46a7802b5ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4519b148e865f993f9c34252fee4d35e4a319a7b69ab7bc1b0d2b23eaba6c227"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fabdc5cb9c8ce80c8d17e2aa3bd5453cbbfa5ea13f2969851b1aab7a9f4b7598"
    sha256 cellar: :any_skip_relocation, sonoma:        "21cdeb12cf5635dd0b98c02232f03e6b6cc0acccc7e5d2e8a290ca744ba50544"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd367091cb17b3fc4f5238ae8dbf4e2f64acea6f4da0dd18939ed9d1b9455109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8c1c23cfa368ca3ab7ee50fdc6f234a5aad0897f766e24221d1c8f2369d0a02"
  end

  depends_on "mill" => :build
  depends_on "scala" => :build
  depends_on "openjdk"

  def install
    ENV["JAVA_HOME"] = Language::Java.java_home
    system "mill", "--no-daemon", "flix.compile"
    system "mill", "--no-daemon", "flix.assembly"
    libexec.install "out/flix/assembly.dest/out.jar" => "flix.jar"
    bin.write_jar_script libexec/"flix.jar", "flix"
  end

  test do
    system bin/"flix", "init"
    assert_match "Hello World!", shell_output("#{bin}/flix run")
    assert_match "Running 1 tests...", shell_output("#{bin}/flix test 2>&1")
  end
end