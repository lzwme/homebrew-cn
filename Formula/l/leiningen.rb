class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https:github.comtechnomancyleiningen"
  url "https:github.comtechnomancyleiningenarchiverefstags2.10.0.tar.gz"
  sha256 "5f4ae6ef2a9665176138730f00ce008b17de96af99a2ce5e4c3f017b2d4d5659"
  license "EPL-1.0"
  head "https:github.comtechnomancyleiningen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "48b5112c02e30233338b114ba4c6bfa70aaa7bac7e4429ef127ddc23703cb620"
  end

  depends_on "openjdk"

  resource "jar" do
    url "https:github.comtechnomancyleiningenreleasesdownload2.10.0leiningen-2.10.0-standalone.jar"
    sha256 "d27299bad34075ac2864d0bd0559f835c6e2c476c0b0a283bcbdb574fdadbb34"
  end

  def install
    libexec.install resource("jar")
    jar = "leiningen-#{version}-standalone.jar"

    # binlein autoinstalls and autoupdates, which doesn't work too well for us
    inreplace "binlein-pkg" do |s|
      s.change_make_var! "LEIN_JAR", libexecjar
    end

    (libexec"bin").install "binlein-pkg" => "lein"
    (libexec"binlein").chmod 0755
    (bin"lein").write_env_script libexec"binlein", Language::Java.overridable_java_home_env
    bash_completion.install "bash_completion.bash" => "lein-completion.bash"
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
    (testpath"project.clj").write <<~EOS
      (defproject brew-test "1.0"
        :dependencies [[org.clojureclojure "1.10.3"]])
    EOS
    (testpath"srcbrew_testcore.clj").write <<~EOS
      (ns brew-test.core)
      (defn adds-two
        "I add two to a number"
        [x]
        (+ x 2))
    EOS
    (testpath"testbrew_testcore_test.clj").write <<~EOS
      (ns brew-test.core-test
        (:require [clojure.test :refer :all]
                  [brew-test.core :as t]))
      (deftest canary-test
        (testing "adds-two yields 4 for input of 2"
          (is (= 4 (tadds-two 2)))))
    EOS
    system "#{bin}lein", "test"
  end
end