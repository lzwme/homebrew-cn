class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https:github.comsoulspace-orgoverarch"
  url "https:github.comsoulspace-orgoverarchreleasesdownloadv0.24.0overarch.jar"
  sha256 "866c95758636b2b5b1c50cc9ad7a5089a53235d30faa4fe5181c4d61231611ce"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c73a2453ef79e04bd160544d9ecadb1f8f39ece29d265f3c477414e2badab97a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c73a2453ef79e04bd160544d9ecadb1f8f39ece29d265f3c477414e2badab97a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c73a2453ef79e04bd160544d9ecadb1f8f39ece29d265f3c477414e2badab97a"
    sha256 cellar: :any_skip_relocation, sonoma:         "c73a2453ef79e04bd160544d9ecadb1f8f39ece29d265f3c477414e2badab97a"
    sha256 cellar: :any_skip_relocation, ventura:        "c73a2453ef79e04bd160544d9ecadb1f8f39ece29d265f3c477414e2badab97a"
    sha256 cellar: :any_skip_relocation, monterey:       "c73a2453ef79e04bd160544d9ecadb1f8f39ece29d265f3c477414e2badab97a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c354ed4cd05d4679b62f5df8aa276b0d56b6a82478a4cccb9a0575a6a445815"
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