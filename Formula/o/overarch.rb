class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https:github.comsoulspace-orgoverarch"
  url "https:github.comsoulspace-orgoverarchreleasesdownloadv0.28.0overarch.jar"
  sha256 "d7db3fc42e57a462323d06f1d95b3340fbddaa2e80d3dc85ddff34aba047fcd6"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d431125387fd12acecdf9eceee71467847ae73157b89893709f26f312bcff2f7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d431125387fd12acecdf9eceee71467847ae73157b89893709f26f312bcff2f7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d431125387fd12acecdf9eceee71467847ae73157b89893709f26f312bcff2f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "1767e72c62b95557c3fc0d55b94a7e0de72d2f84141f9512f8808bc2027f525f"
    sha256 cellar: :any_skip_relocation, ventura:        "1767e72c62b95557c3fc0d55b94a7e0de72d2f84141f9512f8808bc2027f525f"
    sha256 cellar: :any_skip_relocation, monterey:       "d431125387fd12acecdf9eceee71467847ae73157b89893709f26f312bcff2f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e01594396ca8a578d9990378ad942f822deb616cf40fb7285365bc0cb12c44c"
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
      {:nodes-by-type-count {:person 1, :system 1},
       :nodes-count 2,
       :views-by-type-count {:container-view 1, :context-view 1},
       :relations-by-type-count {:rel 1},
       :views-count 2,
       :elements-by-namespace-count {nil 3},
       :relations-count 1,
       :synthetic-count {:normal 3},
       :external-count {:internal 3}}
    EOS
    assert_equal expected, shell_output("#{bin}overarch --model-dir=#{testpath} --model-info").chomp
  end
end