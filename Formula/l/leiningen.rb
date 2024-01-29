class Leiningen < Formula
  desc "Build tool for Clojure"
  homepage "https:github.comtechnomancyleiningen"
  url "https:github.comtechnomancyleiningenarchiverefstags2.11.0.tar.gz"
  sha256 "8553676fa19eb11aec38654dc5d84d773a4bcf9f2fa265580dd296223c219d26"
  license "EPL-1.0"
  head "https:github.comtechnomancyleiningen.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3590ed9c1cfc2a13bc047487b11898729ac92aab5675e53d7098733187c62974"
  end

  depends_on "openjdk"

  resource "jar" do
    url "https:github.comtechnomancyleiningenreleasesdownload2.11.0leiningen-2.11.0-standalone.jar"
    sha256 "83ab3c11f703f629d2e0ba55107f276af00abf7e497d1957276528f332c4c3f5"
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