class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https:github.comsoulspace-orgoverarch"
  url "https:github.comsoulspace-orgoverarchreleasesdownloadv0.27.0overarch.jar"
  sha256 "d4b80471920555bc44a45a227b429d9d3a0555e476bee8ae29d2bf9d59812bd5"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f65fe1a190249071dc17e23c7b9dc57a6b462099bd17beedeaed21bf5c0485ad"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f65fe1a190249071dc17e23c7b9dc57a6b462099bd17beedeaed21bf5c0485ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f65fe1a190249071dc17e23c7b9dc57a6b462099bd17beedeaed21bf5c0485ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "c20b105b107c62aaeb38d528947929d4d8fe53a4edc5fd5bf558c8a3ddf59fbd"
    sha256 cellar: :any_skip_relocation, ventura:        "c20b105b107c62aaeb38d528947929d4d8fe53a4edc5fd5bf558c8a3ddf59fbd"
    sha256 cellar: :any_skip_relocation, monterey:       "f65fe1a190249071dc17e23c7b9dc57a6b462099bd17beedeaed21bf5c0485ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0dd6a61bd43c2848b1b260e1602b0b4e16fc3fe11842ff436196916202a158f"
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