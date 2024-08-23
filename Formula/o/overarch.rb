class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https:github.comsoulspace-orgoverarch"
  url "https:github.comsoulspace-orgoverarchreleasesdownloadv0.30.0overarch.jar"
  sha256 "adb2328ce0e28cf36ce665cdfdb25b8be9902f475d8153d5c9c5b0a914856c5c"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "59eb0159f6afab4914a8dd8319e516170041b9d1ea2b444b9e95fb832f5d190c"
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