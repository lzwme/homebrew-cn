class Nng < Formula
  desc "Nanomsg-next-generation -- light-weight brokerless messaging"
  homepage "https:nanomsg.github.ionng"
  url "https:github.comnanomsgnngarchiverefstagsv1.7.0.tar.gz"
  sha256 "668325161637a0debcf7fb4340919b81e74b66d38bc7a663e8b55b7e0abd7f57"
  license "MIT"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "fadb8964b6dbe4138c4282781319e05f6b617234fba31241f8db422467369109"
    sha256 cellar: :any,                 arm64_ventura:  "3cfdfa0eb104d3806bfea23a2aa916fba212bd5d5bb3c197c6fc4740663dd881"
    sha256 cellar: :any,                 arm64_monterey: "96d2510e71c909f97e557e6e411bcc5b69f500bd1f8fe5eb0d44620d77d1c225"
    sha256 cellar: :any,                 sonoma:         "5aca997246d67fa647f8d96f25000fd5a3f955a1c6c951755b59bd827c13e1ee"
    sha256 cellar: :any,                 ventura:        "5c75bbc11fcb5ee61ed5042e7c11887aaba6e43b320ff484392906953a7b710a"
    sha256 cellar: :any,                 monterey:       "c6c83e98d7b4c8d36a77b9fdf05f497348cd09d9f2010f65d29f9e37adfef671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06f4c4e2bb9d6eabb2ec42972556c0b77c1ff716e30d17520b35e3aa81d97f86"
  end

  depends_on "asciidoctor" => :build
  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-G", "Ninja",
                    "-DNNG_ENABLE_DOC=ON",
                    "-DBUILD_SHARED_LIBS=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    bind = "tcp:127.0.0.1:#{free_port}"

    fork do
      exec "#{bin}nngcat --rep --bind #{bind} --format ascii --data home"
    end
    sleep 2

    output = shell_output("#{bin}nngcat --req --connect #{bind} --format ascii --data brew")
    assert_match(home, output)
  end
end