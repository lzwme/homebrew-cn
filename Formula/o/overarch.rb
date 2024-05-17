class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https:github.comsoulspace-orgoverarch"
  url "https:github.comsoulspace-orgoverarchreleasesdownloadv0.17.0overarch.jar"
  sha256 "9e763a5a7ebcb20744bd0c600a3f63632f53389b29996736c16102e17d715ee3"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "367c555fb598985b96cccdbc5ffa1e93f8f9bd5a9cfd6f67c0348788a337952d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77d943ab32c7a677ed9a668bb26e7a4346b446dfa88c9dc5303a4d07da75569a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "05eaeb4b687599bac6eee55d4b9fab5339303b94866f594a5c501b4a246dd201"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7dc38d1a1ea9d2b6fabe407a9df12e33bdb47ac31522ff48c9cf1d26dfa2266"
    sha256 cellar: :any_skip_relocation, ventura:        "b0db4fa132db9ca12c9ce652447adcb6639b9401cdc2445e879a5aed4e78effa"
    sha256 cellar: :any_skip_relocation, monterey:       "abcdcfa76e571f79540e3c5da749d8094bc6c1b4ceec5f243de7bf0b829321a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34193256bb7574156ea42254002ceff099724ccfa671a1e10da9e697f6579504"
  end

  head do
    url "https:github.comsoulspace-orgoverarch.git", branch: "main"
    depends_on "leiningen" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "lein", "uberjar"
      jar = "targetoverarch.jar"
    else
      jar = "overarch.jar"
    end

    libexec.install jar
    bin.write_jar_script libexec"overarch.jar", "overarch"
  end

  test do
    (testpath"test.edn").write <<~EOS
      \#{
        {:el :person
         :id :test-customer}
        {:el :system
         :id :test-system}
        {:el :rel
         :id :customer-uses-system
         :from :test-customer
         :to :test-system}
        {:el :context-view
         :id :test-context-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}
        {:el :container-view
         :id :test-container-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}}
    EOS
    expected = <<~EOS.chomp
      Model Warnings:
      {:unresolved-refs-in-views (), :unresolved-refs-in-relations ()}
      Model Information:
      {:namespaces {nil 3},
       :relations 1,
       :views-types {:container-view 1, :context-view 1},
       :external {:internal 3},
       :nodes-types {:person 1, :system 1},
       :nodes 2,
       :synthetic {:normal 3},
       :relations-types {:rel 1},
       :views 2}
    EOS
    assert_equal expected, shell_output("#{bin}overarch --model-dir=#{testpath} --model-info").chomp
  end
end