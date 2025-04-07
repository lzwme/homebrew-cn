class ApacheFlink < Formula
  desc "Scalable batch and stream data processing"
  homepage "https:flink.apache.org"
  url "https:www.apache.orgdyncloser.lua?path=flinkflink-2.0.0flink-2.0.0-bin-scala_2.12.tgz"
  mirror "https:archive.apache.orgdistflinkflink-2.0.0flink-2.0.0-bin-scala_2.12.tgz"
  version "2.0.0"
  sha256 "04fe5be9841a10d30e0e1cd682ec4d015a86603f710f2f857c43c75beae97aad"
  license "Apache-2.0"
  head "https:github.comapacheflink.git", branch: "master"

  livecheck do
    url "https:flink.apache.orgdownloads"
    regex(href=.*?flink[._-]v?(\d+(?:\.\d+)+)-bin[^"' >]*?\.ti)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab20a5e33f83e6aa4d71d256529eefcc5345def0b8c8a1a7de77b177511c1afc"
  end

  # Java 11, 17 (Default), and 21 are supported.
  # See: https:github.comapacheflink?tab=readme-ov-file#building-apache-flink-from-source
  depends_on "openjdk@21"

  def install
    inreplace "confconfig.yaml" do |s|
      s.sub!(^env:, "env.java.home: #{Language::Java.java_home("21")}\n\\0")
    end
    libexec.install Dir["*"]
    bin.write_exec_script libexec"binflink"
  end

  test do
    (testpath"log").mkpath
    (testpath"input").write "foo bar foobar"
    expected = <<~EOS
      (foo,1)
      (bar,1)
      (foobar,1)
    EOS
    ENV.prepend "_JAVA_OPTIONS", "-Djava.io.tmpdir=#{testpath}"
    ENV.prepend "FLINK_LOG_DIR", testpath"log"
    system libexec"binstart-cluster.sh"
    system bin"flink", "run", "-p", "1",
           libexec"examplesstreamingWordCount.jar", "--input", testpath"input",
           "--output", testpath"result"
    system libexec"binstop-cluster.sh"
    assert_path_exists testpath"result"
    result_files = Dir[testpath"result**"]
    assert_equal 1, result_files.length
    assert_equal expected, (testpathresult_files.first).read
  end
end