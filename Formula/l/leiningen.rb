class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https:github.comtechnomancyleiningen"
  url "https:github.comtechnomancyleiningenarchiverefstags2.11.2.tar.gz"
  sha256 "fe9ee17786be6c3cf4615688a2a82c173369657d84c1b2ffc00b7cd5fd7df1bc"
  license "EPL-1.0"
  head "https:github.comtechnomancyleiningen.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "131114eee9aa0c25867ebf065360d52bbfaef43906308b747ea6cd9b033326f6"
  end

  depends_on "openjdk"

  resource "jar" do
    url "https:github.comtechnomancyleiningenreleasesdownload2.11.2leiningen-2.11.2-standalone.jar"
    sha256 "7d31ae23ae769e927438b0cd55d15a93e7dabab09fd4fc15877979161e108774"

    livecheck do
      formula :parent
    end
  end

  def install
    odie "jar resource needs to be updated" if build.stable? && version != resource("jar").version

    libexec.install resource("jar")
    jar = "leiningen-#{version}-standalone.jar"

    # binlein autoinstalls and autoupdates, which doesn't work too well for us
    inreplace "binlein-pkg" do |s|
      s.change_make_var! "LEIN_JAR", libexecjar
    end

    (libexec"bin").install "binlein-pkg" => "lein"
    (libexec"binlein").chmod 0755
    (bin"lein").write_env_script libexec"binlein", Language::Java.overridable_java_home_env
    bash_completion.install "bash_completion.bash" => "lein"
    zsh_completion.install "zsh_completion.zsh" => "_lein"
  end

  def caveats
    <<~EOS
      Dependencies will be installed to:
        $HOME.m2repository
      To play around with Clojure run `lein repl` or `lein help`.
    EOS
  end

  test do
    (testpath"project.clj").write <<~CLOJURE
      (defproject brew-test "1.0"
        :dependencies [[org.clojureclojure "1.10.3"]])
    CLOJURE

    (testpath"srcbrew_testcore.clj").write <<~CLOJURE
      (ns brew-test.core)
      (defn adds-two
        "I add two to a number"
        [x]
        (+ x 2))
    CLOJURE

    (testpath"testbrew_testcore_test.clj").write <<~CLOJURE
      (ns brew-test.core-test
        (:require [clojure.test :refer :all]
                  [brew-test.core :as t]))
      (deftest canary-test
        (testing "adds-two yields 4 for input of 2"
          (is (= 4 (tadds-two 2)))))
    CLOJURE

    system bin"lein", "test"
  end
end